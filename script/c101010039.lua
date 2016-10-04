--機夜行襲雷竜－ミッドナイト
function c101010039.initial_effect(c)
c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c101010039.fscondition)
	e1:SetOperation(c101010039.fsoperation)
	c:RegisterEffect(e1)
	--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010039.descon)
	e2:SetOperation(c101010039.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c101010039.tg)
	e3:SetOperation(c101010039.op)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101010039)
	e4:SetTarget(c101010039.sptg)
	e4:SetOperation(c101010039.spop)
	c:RegisterEffect(e4)
end
function c101010039.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)
end
function c101010039.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then
		local mg=g:Filter(Card.IsFusionSetCard,gc,0x167)
		return (gc:IsFusionSetCard(0x167) and mg:IsExists(c101010039.ffilter,1,nil)) or (c101010039.ffilter(gc) and mg:GetCount()>0)
	end
	local fs=false
	local mg=g:Filter(Card.IsFusionSetCard,nil,0x167)
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:IsExists(c101010039.ffilter,1,nil) and mg:GetCount()>0 and (fs or chkf==PLAYER_NONE)
end
function c101010039.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local sg=eg:Filter(Card.IsFusionSetCard,gc,0x167)
		local g=Group.FromCards(gc)
		for i=1,5 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g:Merge(sg:Select(tp,1,1,nil))
			sg:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
			if i==5 or sg:FilterCount(Card.IsFusionSetCard,gc,0x167)==0 or not Duel.SelectYesNo(tp,aux.Stringid(101010038,0)) then break end
		end
		Duel.SetFusionMaterial(g)
		return
	end
	local sg1=eg:Filter(c101010039.ffilter,nil)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg1:Select(tp,1,1,nil) end
	local sg2=eg:Filter(Card.IsFusionSetCard,nil,0x167)
	local g2=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2:Merge(sg2:Select(tp,1,1,nil))
		sg2:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		if i==5 or sg2:FilterCount(Card.IsFusionSetCard,nil,0x167)==0 or not Duel.SelectYesNo(tp,aux.Stringid(101010038,0)) then break end
	end
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c101010039.desfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsDestructable()
end
function c101010039.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010039.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c101010039.desfilter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c101010039.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010039.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010039.spfilter(c,e,tp)
	return c:IsSetCard(0x167) and c:GetCode()~=101010039 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010039.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101010039.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010039.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
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
