--デュエル・アカデミア・ハイツ (アクション デゥエル モード)
local id,ref=GIR()
function ref.start(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetOperation(ref.op)
	c:RegisterEffect(e2)
	--fusion
	local fus=Effect.CreateEffect(c)
	fus:SetCategory(CATEGORY_SPECIAL_SUMMON)
	fus:SetType(EFFECT_TYPE_IGNITION)
	fus:SetRange(LOCATION_FZONE)
	fus:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	fus:SetTarget(ref.fustg)
	fus:SetOperation(ref.fusop)
	c:RegisterEffect(fus)
	--tag out
	local tag=Effect.CreateEffect(c)
	tag:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	tag:SetRange(LOCATION_FZONE)
	tag:SetCode(EFFECT_SEND_REPLACE)
	tag:SetTarget(ref.tagtg)
	tag:SetValue(ref.tagval)
	tag:SetOperation(ref.tagop)
	c:RegisterEffect(tag)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_CONTROL_CHANGED)
	e1:SetCondition(ref.tagcon2)
	e1:SetTarget(ref.tagtg2)
	e1:SetOperation(ref.tagop2)
	c:RegisterEffect(e1)
	--no response to Extra Deck summon
	local nr1=Effect.CreateEffect(c)
	nr1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	nr1:SetCode(EVENT_SPSUMMON_SUCCESS)
	nr1:SetRange(LOCATION_FZONE)
	nr1:SetCondition(ref.nrcon)
	nr1:SetOperation(ref.nrop)
	c:RegisterEffect(nr1)
	local nr2=Effect.CreateEffect(c)
	nr2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	nr2:SetRange(LOCATION_FZONE)
	nr2:SetCode(EVENT_CHAIN_END)
	nr2:SetOperation(ref.nrop2)
	c:RegisterEffect(nr2)
end
-- function ref.tagcon(e,tp,eg,ep,ev,re,r,rp)
	-- local tc=eg:GetFirst()
	-- return tc:GetLocation()~=0x40 and (tc:IsType(TYPE_FUSION) or tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_XYZ))
-- end
function ref.tagcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsType(TYPE_FUSION) or tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_XYZ)
end
function ref.tfilter(c)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:GetTextAttack()~=-2
end
function ref.tagtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return re~=e and eg:IsExists(ref.filter2,1,nil,e) and Duel.GetLocationCount(tc:GetOwner(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(ref.tfilter,tc:GetOwner(),LOCATION_EXTRA,0,1,nil,e)
	end
	if eg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tc:GetControler(),HINTMSG_TARGET)
		tc=eg:Select(tc:GetControler(),1,1,nil):GetFirst()
	end
	e:SetLabelObject(tc)
	Duel.SendtoDeck(tc,nil,0,REASON_EFFECT+REASON_REPLACE)
	return true
end
function ref.tagval(e,c)
	return ref.filter2(c,e)
end
function ref.tagtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tc:GetOwner(),LOCATION_MZONE)>0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(ref.tfilter,tc:GetOwner(),LOCATION_EXTRA,0,1,nil,e)
	end
	if eg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tc:GetControler(),HINTMSG_TARGET)
		tc=eg:Select(tc:GetControler(),1,1,nil):GetFirst()
	end
	e:SetLabelObject(tc)
end
function ref.lvfilter(c,lv)
	return c:GetLevel()==lv
end
function ref.tagop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local exg=Duel.GetMatchingGroup(ref.tfilter,tc:GetOwner(),LOCATION_EXTRA,0,tc,e)
	if Duel.GetLocationCount(tc:GetOwner(),LOCATION_MZONE)>0 and exg:GetCount()>0 then
		local ex=exg:RandomSelect(tc:GetOwner(),1):GetFirst()
		local st=SUMMON_TYPE_FUSION
		if ex:IsType(TYPE_SYNCHRO) then st=SUMMON_TYPE_SYNCHRO
		elseif ex:IsType(TYPE_XYZ) then st=SUMMON_TYPE_XYZ end
		if Duel.SpecialSummon(ex,st,tc:GetOwner(),tc:GetOwner(),false,true,POS_FACEUP_ATTACK) and st==SUMMON_TYPE_XYZ then
			local g=Duel.GetMatchingGroup(Card.IsType,tc:GetOwner(),LOCATION_HAND,0,nil,TYPE_MONSTER)
			Duel.Hint(HINT_SELECTMSG,tc:GetOwner(),HINTMSG_XMATERIAL)
			local oc=g:Select(tc:GetOwner(),1,1,nil)
			local lv=oc:GetFirst():GetLevel()
			local oc2=g:FilterSelect(tc:GetOwner(),ref.lvfilter,1,1,oc:GetFirst(),lv)
			oc:Merge(oc2)
			Duel.Overlay(ex,oc)
		end
		ex:CompleteProcedure()
	end
end
function ref.tagop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if eg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tc:GetOwner(),HINTMSG_TARGET)
		tc=eg:Select(tc:GetOwner(),1,1,nil):GetFirst()
	end
	Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	local exg=Duel.GetMatchingGroup(ref.tfilter,tc:GetOwner(),LOCATION_EXTRA,0,tc,e)
	if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tc:GetOwner(),LOCATION_MZONE)>0 and exg:GetCount()>0 then
		local ex=exg:RandomSelect(tc:GetOwner(),1):GetFirst()
		local st=SUMMON_TYPE_FUSION
		if ex:IsType(TYPE_SYNCHRO) then st=SUMMON_TYPE_SYNCHRO
		elseif ex:IsType(TYPE_XYZ) then st=SUMMON_TYPE_XYZ end
		if Duel.SpecialSummon(ex,st,tc:GetOwner(),tc:GetOwner(),false,true,POS_FACEUP_ATTACK) and st==SUMMON_TYPE_XYZ then
			local g=Duel.GetMatchingGroup(Card.IsType,tc:GetOwner(),LOCATION_HAND,0,nil,TYPE_MONSTER)
			Duel.Hint(HINT_SELECTMSG,tc:GetOwner(),HINTMSG_XMATERIAL)
			local oc=g:Select(tc:GetOwner(),1,1,nil)
			local lv=oc:GetFirst():GetLevel()
			local oc2=g:FilterSelect(tc:GetOwner(),ref.lvfilter,1,1,oc:GetFirst(),lv)
			oc:Merge(oc2)
			Duel.Overlay(ex,oc)
		end
		ex:CompleteProcedure()
	end
end
function ref.filter2(c,e)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and (c:GetDestination()~=LOCATION_OVERLAY or c:GetDestination()~=LOCATION_EXTRA) and c:IsOnField() and c:IsControler(c:GetOwner()) --and c==e:GetLabelObject()
end
function ref.nrcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:GetPreviousLocation()==LOCATION_EXTRA
end
function ref.nrop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(ref.nrfilter)
		else
		e:GetHandler():RegisterFlagEffect(101010004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function ref.nrop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(101010004)~=0 then
		Duel.SetChainLimitTillChainEnd(ref.nrfilter)
	end
	e:GetHandler():ResetFlagEffect(101010004)
end
function ref.nrfilter(e,tp,rp)
	return rp~=tp
end
function ref.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function ref.filter3(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
	and c:CheckFusionMaterial(m,nil,chkf)
end
function ref.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(ref.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(ref.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(ref.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(ref.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(ref.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(ref.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
function ref.filter(c)
	return c:GetCode()~=101010004
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)  
	if Duel.GetMatchingGroup(ref.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil):GetCount()>39
		and tc==nil then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if tc2==nil then
			local token=Duel.CreateToken(tp,101010004,nil,nil,nil,nil,nil,nil)  
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		end
		else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_RULE)
	end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
