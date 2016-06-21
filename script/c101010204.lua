--Blitzkrieg Meknight Dragon - Eclipse
local id,ref=GIR()
function ref.start(c)
c:EnableReviveLimit()
	--fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(ref.fscondition)
	e0:SetOperation(ref.fsoperation)
	c:RegisterEffect(e0)
	--self-destruct
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(ref.descon)
	e3:SetOperation(ref.desop)
	c:RegisterEffect(e3)
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(0xf3)
	e1:SetTargetRange(0xf3,0)
	e1:SetCondition(ref.atcon)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(ref.dscon)
	e2:SetTarget(ref.dstg)
	e2:SetOperation(ref.dsop)
	c:RegisterEffect(e2)
	if not ref.global_check then
		ref.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabel(id)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(e1,0)
	end
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(0x32)
	e4:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e4:SetCondition(ref.con)
	e4:SetTarget(ref.target)
	e4:SetOperation(ref.activate)
	c:RegisterEffect(e4)
end
function ref.spfilter(c,mg)
	return (c:IsCode(id) or c:IsCode(id))--IsSetCard(0x167) and c:IsType(TYPE_PENDULUM)
		and mg:IsExists(ref.fffilter,1,c,0)
end
function ref.fffilter(c,code)
	return c:IsSetCard(0x167) and c:GetCode()~=code
end
function ref.fscondition(e,mg,gc)
	if mg==nil then return false end
	if gc then return false end
	return mg:IsExists(ref.spfilter,1,nil,mg)
end
function ref.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,ref.spfilter,1,1,nil,eg)
	local code=0
	while eg:IsExists(ref.fffilter,1,g1:GetFirst(),code) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=eg:FilterSelect(tp,ref.fffilter,1,1,g1:GetFirst(),code)
		g1:AddCard(g2:GetFirst())
		code=g2:GetFirst():GetCode()
		eg:Remove(Card.IsCode,nil,code)
		if not eg:IsExists(ref.fffilter,1,g1:GetFirst(),code) or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then break end
	end
	Duel.SetFusionMaterial(g1)
end
function ref.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function ref.atcon(e,c)
	return c==e:GetHandler()
end
function ref.dscon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function ref.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function ref.exfilter(c)
	return not c:IsType(TYPE_PENDULUM)
end
function ref.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and ref.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetHandler():GetMaterial():FilterCount(ref.exfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function ref.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function ref.dsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local dg=Group.CreateGroup()
	if ct>0 then
		local g=Duel.GetMatchingGroup(ref.dfilter,tp,LOCATION_DECK+LOCATION_MZONE,LOCATION_MZONE,nil)
		--for i=1,ct
		while ct>0 and g:GetCount()>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				dg:AddCard(tc)
				g:Remove(Card.IsCode,nil,tc:GetCode())
			end
			ct=ct-1
			if ct==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then break end
		end
		Duel.Destroy(dg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(ref.tg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function ref.tg(e,c)
	return not (c:IsSetCard(0x167) and c:IsType(TYPE_FUSION))
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function ref.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function ref.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x167) and c:GetCode()~=id and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(ref.filter1,tp,LOCATION_GRAVE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				res=Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(ref.filter1,tp,LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(ref.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		sg2=Duel.GetMatchingGroup(ref.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
