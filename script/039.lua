--機夜行襲雷竜－ミッドナイト
function c101010098.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c101010098.fscondition)
	e1:SetOperation(c101010098.fsoperation)
	c:RegisterEffect(e1)
	--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010098.descon)
	e2:SetOperation(c101010098.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c101010098.tg)
	e3:SetOperation(c101010098.op)
	c:RegisterEffect(e3)
	--desreg
	if not c101010098.global_check then
		c101010098.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabel(101010098)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(e1,0)
	end
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(0x32)
	e4:SetCountLimit(1,101010098)
	e4:SetCondition(c101010098.con)
	e4:SetTarget(c101010098.sptg)
	e4:SetOperation(c101010098.spop)
	c:RegisterEffect(e4)
end
function c101010098.ffilter(c,code)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:GetCode()~=code
end
function c101010098.spffilter(c,mg)
	return c:IsSetCard(0x167)
		and mg:IsExists(c101010098.ffilter,1,c)
end
function c101010098.fscondition(e,mg,gc)
	if mg==nil then return false end
	if gc then return false end
	return mg:IsExists(c101010098.spffilter,1,nil,mg)
end
function c101010098.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,c101010098.spffilter,1,1,nil,eg)
	local code=0
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=eg:FilterSelect(tp,c101010098.ffilter,1,1,g1:GetFirst(),code)
		g1:AddCard(g2:GetFirst())
		code=g2:GetFirst():GetCode()
		eg:Remove(Card.IsCode,nil,code)
		if not eg:IsExists(c101010098.ffilter,1,g1:GetFirst()) or not Duel.SelectYesNo(tp,aux.Stringid(101010098,0)) then break end
	end
	Duel.SetFusionMaterial(g1)
end
function c101010098.desfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsDestructable()
end
function c101010098.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010098.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c101010098.desfilter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c101010098.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010098.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010098.spfilter(c,e,tp)
	return c:IsSetCard(0x167) and c:GetCode()~=101010098 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010098.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101010098)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101010098.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010098.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101010098.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010098.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
