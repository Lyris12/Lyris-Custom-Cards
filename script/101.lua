--襲雷属性－地球
function c101010085.initial_effect(c)
	--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010085.descon)
	e2:SetOperation(c101010085.desop)
	c:RegisterEffect(e2)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--desreg
	if not c101010085.global_check then
		c101010085.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabel(101010085)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(e1,0)
	end
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0x32)
	e1:SetCountLimit(1,101010085)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101010085.con)
	e1:SetTarget(c101010085.target)
	e1:SetOperation(c101010085.operation)
	c:RegisterEffect(e1)
end
function c101010085.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010085.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010085.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101010085)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101010085.filter(c,e,tp)
	return c:IsSetCard(0x167) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetCode()~=101010085
end
function c101010085.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010085.filter(chkc,e,tp) end
	if chk==0 then return c:IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101010085.filter,tp,LOCATION_GRAVE,0,1,c,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010085.filter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c101010085.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,REASON_EFFECT) then
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e0=Effect.CreateEffect(c)
			e0:SetDescription(1124)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_PHASE+PHASE_END)
			e0:SetCountLimit(1)
			e0:SetRange(LOCATION_MZONE)
			e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e0:SetOperation(c101010085.desop)
			tc:RegisterEffect(e0,true)
		end
	end
end
function c101010085.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
